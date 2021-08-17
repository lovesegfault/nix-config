{ ... }: {
  networking.firewall.extraCommands = ''
    iptables -A INPUT -m mac --mac-source e4:5f:01:2a:4e:88 -j ACCEPT
  '';
  services.hqplayerd = {
    enable = true;
    auth = {
      username = "admin";
      password = "admin";
    };
    openFirewall = true;
    config = ''
      <?xml version="1.0" encoding="utf-8"?>
      <xml>
        <engine
          auto_family="0"
          channels="2"
          cuda="1"
          direct_sdm="0"
          dsd_6db="1"
          pdm_conv="9"
          pdm_filt="0"
          quick_pause="1"
          sdm_conversion="0"
          sdm_integrator="0"
          short_buffer="1"
          volume_adaptive="1"
          volume_max="0"
          volume_min="-60"
        >
          <network
            address="camus"
            any_dsd="0"
            dac_bits="0"
            device="hw:CARD=D90SE,DEV=0"
            friendly_name="camus: D90SE: USB Audio"
            ipv6="0"
            pack_sdm="0"
            period_time="0"
          />

          <defaults bitrate="12288000" samplerate="768000" volume="-3"/>
          <matrix enabled="1" engine="1" expand_hf="1">
            <pipeline channel="0" gain="0" mixdown="0" process="/var/lib/hqplayer/home/impulse_0-0.wav" source="0"/>
            <pipeline channel="1" gain="0" mixdown="1" process="/var/lib/hqplayer/home/impulse_1-0.wav" source="1"/>
          </matrix>
        </engine>
        <title value="HQPlayerEmbedded"/>
        <output type="network"/>
        <mode value="sdm"/>
        <log enabled="1"/>
        <pcm dither="9" filter="23" filter1x="23" samplerate="0"/>
        <sdm bitrate="0" modulator="11" oversampling="22" oversampling1x="22"/>
      </xml>
    '';
  };
}
