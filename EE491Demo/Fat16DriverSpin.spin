{
    Author:  Steve

    First attempt at a FAT16 driver build on top of the SD card driver.

    Work in progress.
}


OBJ
    sd  : "SdDriverSpin"

VAR
    byte sectorsPerCluster
    word reservedSectors
    byte numberOfFats
    long numberOfSectors
    word sectorsPerFat
    long hiddenSectors

    long fatSizeInSectors
    long rootSizeInSectors
    long dataSizeInSectors
    long fatStartSector
    long rootStartSector
    long dataStartSector

    long firstCluster
    long fileSize

    byte buffer[512]
    byte nameBuffer[13]

PUB Start

    sd.Start
    ReadBootSector

PRI ReadBootSector | bytesPerSector, numberOfRootEntries, smallNumberOfSectors, mediaDescriptor, largeNumberOfSectors, signature

    sd.ReadBlock(@buffer, $00_0000)

    bytesPerSector := buffer[$0B] | buffer[$0C] << 8
    if bytesPerSector <> 512
        return false

    sectorsPerCluster := buffer[$0D]

    reservedSectors := buffer[$0E] | buffer[$0F] << 8

    numberOfFats := buffer[$10]

    numberOfRootEntries := buffer[$11] | buffer[$12] << 8
    if numberOfRootEntries <> 512
        return false

    smallNumberOfSectors := buffer[$13] | buffer[$14] << 8

    mediaDescriptor := buffer[$15]
    if mediaDescriptor <> $F8
        return false

    sectorsPerFat := buffer[$16] | buffer[$17] << 8

    hiddenSectors := buffer[$1C] | buffer[$1D] << 8 | buffer[$1E] << 16 | buffer[$1F] << 24

    if smallNumberOfSectors <> 0
        numberOfSectors := smallNumberOfSectors
    else
        largeNumberOfSectors := buffer[$20] | buffer[$21] << 8 | buffer[$22] << 16 | buffer[$23] << 24
        numberOfSectors := largeNumberOfSectors

    if buffer[$36] <> "F" or buffer[$37] <> "A" or buffer[$38] <> "T" or buffer[$39] <> "1" or buffer[$3A] <> "6"
        return false

    signature := buffer[$1FE] | buffer[$1FF] << 8
    if signature <> $AA55
        return false

    fatSizeInSectors := numberOfFats * sectorsPerFat
    rootSizeInSectors := 32
    dataSizeInSectors := numberOfSectors - (reservedSectors + fatSizeInSectors + rootSizeInSectors)

    fatStartSector := reservedSectors
    rootStartSector := fatStartSector + fatSizeInSectors
    dataStartSector := rootStartSector + rootSizeInSectors

    return true

PRI GetNameFromEntry(entry) | i, n

    n := 0
    repeat i from 0 to 7
        if byte[entry][i] == $20
            quit
        nameBuffer[n++] := byte[entry][i]

    nameBuffer[n++] := "."

    repeat i from 8 to 10
        if byte[entry][i] == $20
            quit
        nameBuffer[n++] := byte[entry][i]

    nameBuffer[n] := 0

PUB OpenFile(name) | i, o, c, a, f

    f := false

    repeat i from 0 to 512-32 step 32
        o := i // 512
        if o == 0
            sd.ReadBlock(@buffer, (rootStartSector + (i / 32)) * 512)

        c := buffer[o + 0]
        if c == $00
            quit

        if c == $E5
            next

        a := buffer[o + 11]

        if (a & $08)
            next

        if (a & $0F) == $0F
            next

        GetNameFromEntry(@buffer + o)
        if strcomp(name, @nameBuffer) == true
            f := true
            quit

    if f
        firstCluster := buffer[o + $1A] | buffer[o + $1B] << 8
        fileSize := buffer[o + $1C] | buffer[o + $1D] << 8 + buffer[o + $1E] << 16 | buffer[o + $1F] << 24

    return f

PUB ReadBlockFromFile(destination)

    if firstCluster == 0
        return false

    sd.ReadBlock(destination, (dataStartSector + (firstCluster - 2) * sectorsPerCluster) * 512)

    return true
