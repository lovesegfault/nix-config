self: super: {
  ffmpeg_4 = super.ffmpeg_4.override { openglSupport = true; libmfxSupport = true; };
}
