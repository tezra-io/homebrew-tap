cask "fermix" do
  version "0.2.2"
  sha256 "6c7a531ad1a4b76c33af2dad0b5008641a7a6c3c0a28f771ba8b83bd2fc87f82"

  url "https://github.com/tezra-io/fermix-macos/releases/download/v#{version}/Fermix-#{version}.dmg"
  name "Fermix"
  desc "Assistant that runs locally and answers wherever you message it"
  homepage "https://github.com/tezra-io/fermix-macos"

  depends_on macos: :sequoia

  app "Fermix.app"

  # The login-item registrations belong to the bundle's own identity, so only
  # the bundle itself can withdraw them, and it does that through its own
  # maintenance entry point. Homebrew runs uninstall directives in a fixed
  # order (Cask::Artifact::AbstractUninstall::ORDERED_DIRECTIVES) and
  # `early_script` is the only one that runs before `quit`, which is what keeps
  # this run from starting a process after the quit has already passed.
  uninstall early_script: {
              executable: "#{appdir}/Fermix.app/Contents/MacOS/Fermix",
              args:       ["--unregister-login-items"],
              sudo:       false,
            },
            quit:         "io.tezra.FermixPet"

  # The home carries the assistant's own data, so it goes only on a zap. The
  # bundle identifier is the pet's by design: the microphone and App Management
  # grants, the login item and the coexistence preflight are all keyed on it.
  zap trash: [
    "~/.fermix",
    "~/Library/Application Support/Fermix",
    "~/Library/Caches/io.tezra.FermixPet",
    "~/Library/Preferences/io.tezra.FermixPet.plist",
  ]

  caveats <<~EOS
    Fermix carries its own engine, so there is nothing else to install.
    An existing Homebrew install's home is adopted in place.
  EOS
end
