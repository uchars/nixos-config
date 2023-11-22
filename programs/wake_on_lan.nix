{ networkInterface, ... }: {
  networking.interfaces."${networkInterface}".wakeOnLan = { enable = true; };
}
