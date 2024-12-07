# Lumi

Gaming Desktop

| Component   | Name                                           | Note                            |
| ----------- | ---------------------------------------------- | ------------------------------- |
| CPU         | AMD Ryzen 5 AMD Ryzen 5 5600X 6-Core Processor |                                 |
| GPU         | NVIDIA GeForce RTX 3060 Ti                     | Used by NixOS                   |
| GPU         | NVIDIA GeForce RTX 1050 Ti                     | Used by Gaming VM               |
| Motherboard | MSI MAG B550 TOMAHAWK                          | See [Motherboard](#motherboard) |

## Motherboard

The B550 has some weird IOMMU grouping.
The GPU which is to be passed to the VM should be plugged into the top PCIE slot.
