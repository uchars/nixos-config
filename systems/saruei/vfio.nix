{ ... } :
{
  boot = {
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
      "vfio_virqfd"

      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];

    # lib.optional enableVfio
    kernelParams = [
      "amd_iommu=on"
    ];
  };


  virtualisation.spiceUSBRedirection.enable = true;
}
