self: super:
let
  ffmpegOverrides = {
    libmfxSupport = true;
    openglSupport = true;
  };
in
{
  ffmpeg_3 = super.ffmpeg_3.override ffmpegOverrides;
  ffmpeg_4 = super.ffmpeg_4.override ffmpegOverrides;
}
