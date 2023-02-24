# Registers

## GPU (Same as Arilla V1)

- `0x20000000`: Control register
    - **31..20** *r/w*: Color to draw (4 bits for red, green and blue)
    - **19..8**: Unused
    - **7..5** *r/w*: Operation code, one of the following:
        - 000: Draw point
        - 001: Draw line
        - 010: Draw rectangle
        - 011: Fill rectangle
        - 100: Get color of pixel
    - **4..3**: Unused
    - **2** *r/w*: Whether the cursor should display 
    - **1** *w*: Whether to run any commands
    - **0** *r/w*: Whether to show anything on VGA
- `0x20000004`: Status register
    - **31..20** *r*: Color that was read from memory (4 bits for red, green and blue)
    - **19..1**: Unused
    - **0** *r*: Whether the GPU is ready to receive a command
- `0x20000008`: Start point of drawing
    - **31..20**: Unused
    - **19..10** *r/w*: Y coordinate of the point
    - **9..0** *r/w*: X coordinate of the point
- `0x2000000C`: End point of drawing
    - **31..20**: Unused
    - **19..10** *r/w*: Y coordinate of the point
    - **9..0** *r/w*: X coordinate of the point

## Keyboard controller

- `0x30000000`: Control/Status register
  - **31..27** *r/w*: Debouncing time
    - 0: Off
    - 31..1: 2^value clock cycles
  - **26** *r/w*: Enable CDC synchronizers
  - **25** *r*: Frame error flag
  - **24** *r*: Parity error flag
  - **23..0** *r*: PS/2 scan code

## Morse code transciever

- `0x40000000`: Control/Status register
  - **31..12**: Unused
  - **11** *w*: Increment input fifo
  - **10** *r/w*: Enable loopback
  - **9** *r/w*: Invert tx/rx lines
  - **8** *r/w*: Sound sample select
  - **7** *r/w*: Sound enable
  - **6** *r*: Transmision in progress
  - **5** *w*: Start transmision
  - **4** *r/w*: Receive enable
  - **3** *r*: Send buffer full
  - **2** *r*: Data available for sending
  - **1** *r*: Receive buffer full
  - **0** *r*: Data available
- `0x40000004`: Bit time register
  - **31..00** *r/w*: Value for bit time clock divider
- `0x40000008`: Data register
  - **31..8**: Unused
  - **7..0** *r*: Data from input FIFO
  - **7..0** *w*: Data to output FIFO