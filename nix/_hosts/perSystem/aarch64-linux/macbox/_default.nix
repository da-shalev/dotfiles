{ ... }: {
  imports = [ ./disko ./home/dashalev.nix ];
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];

  system.stateVersion = "25.11";
}
