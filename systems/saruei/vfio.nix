let
  gpuIDs = [
    "10de:1c82" # Graphics
    "10de:0fb9" # Audio
  ];
in { lib, ... }: {
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"

      #"nvidia"
      #"nvidia_modeset"
      #"nvidia_uvm"
      #"nvidia_drm"
    ];

    # lib.optional enableVfio
    kernelParams = [
      # enable IOMMU
      "amd_iommu=on"
    ] ++ lib.optional true ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
