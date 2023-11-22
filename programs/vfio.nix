{ lib, iommu, gpuIDs, ... }: {
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

    kernelParams = [ "${iommu}=on" ]
      ++ lib.optional true ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
