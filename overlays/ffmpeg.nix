self: super: {
  ffmpeg_3 = super.ffmpeg_3.override { openglSupport = true; libmfxSupport = true; };
  ffmpeg_4 = super.ffmpeg_4.override { openglSupport = true; libmfxSupport = true; };
}
