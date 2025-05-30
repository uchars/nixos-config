{ lib, config, ... }:
{
  options.settings.vfio = with lib; {
    enable = mkEnableOption "Enable VFIO";
    iommu = mkOption {
      type =
        with types;
        enum [
          "amd_iommu"
          "intel_iommu"
        ];
      description = "Processor to enable IOMMU for.";
    };
    pci-ids = mkOption {
      type = with types; listOf str;
      description = ''
        PCI IDs in the format "vendor:product".
        IDs can be obtained using ./scripts/iommugroups.sh
      '';
    };
  };

  config =
    let
      cfg = config.settings.vfio;
    in
    lib.mkIf cfg.enable {
      hardware.opengl.enable = true;
      boot = {
        kernelParams =
          [ "${cfg.iommu}=on" ]
          ++ lib.optional (builtins.length cfg.pci-ids > 0) (
            "vfio-pci.ids=" + lib.concatStringsSep "," cfg.pci-ids
          );

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
      };
    };
}
