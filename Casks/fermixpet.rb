cask "fermixpet" do
  version "0.2.5"
  sha256 "20d2717da9c7320b58f98202669995d9ffac64ba53f63662b143485a594d6a09"

  url "https://github.com/tezra-io/fermix-macos/releases/download/fermixpet-v#{version}/FermixPet-#{version}.dmg"
  name "Fermix"
  desc "Floating voice companion for Fermix"
  homepage "https://github.com/tezra-io/fermix-macos"

  depends_on macos: :ventura

  app "FermixPet.app"

  uninstall quit: "io.tezra.FermixPet"

  zap trash: "~/Library/Caches/io.tezra.FermixPet"

  caveats <<~EOS
    FermixPet talks to a running Fermix daemon over $FERMIX_HOME/realtime.sock and
    needs Realtime voice enabled there — that requires an OpenAI API key (a Codex
    subscription / OAuth login does NOT authorize the Realtime API). Check with:
      fermix voice status

    If you previously ran a source build from ~/Applications, remove it first so
    the two copies don't fight over the microphone grant:
      rm -rf ~/Applications/FermixPet.app
      tccutil reset Microphone io.tezra.FermixPet
  EOS
end
