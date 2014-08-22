program Project1;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  avutil in '../../../libavutil/avutil.pas',
  avcodec in '../../../libavcodec/avcodec.pas',
  avformat in '../../../libavformat/avformat.pas',
  swresample in '../../../libswresample/swresample.pas',
  postprocess in '../../../libpostproc/postprocess.pas',
  avdevice in '../../../libavdevice/avdevice.pas',
  swscale in '../../../libswscale/swscale.pas';



var
  VERSION ,
  MAJOR, MINOR , MICRO: longint;
begin
  try

    av_register_all();

    writeln('');
    writeln(format('Configuration: %s', [string(avformat_configuration)]));
    writeln('');

    writeln(format('License: %s', [string(avformat_license)]));

    VERSION:=avutil_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_AVUTIL:     %s.dll     %s', [LIB_AVUTIL, AV_VERSION(MAJOR, MINOR, MICRO)]));

    VERSION:=postproc_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_POSTPROC:   %s.dll   %s', [LIB_POSTPROC, AV_VERSION(MAJOR, MINOR, MICRO)]));

    VERSION:=avcodec_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_AVCODEC:    %s.dll    %s', [LIB_AVCODEC, AV_VERSION(MAJOR, MINOR, MICRO)]));

    VERSION:=avformat_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_AVFORMAT    %s.dll   %s', [LIB_AVFORMAT, AV_VERSION(MAJOR, MINOR, MICRO)]));

    VERSION:=avdevice_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_AVDEVICE:   %s.dll   %s', [LIB_AVDEVICE, AV_VERSION(MAJOR, MINOR, MICRO)]));

    VERSION:=swscale_version();
    MAJOR:= VERSION shr 16;
    MINOR:= VERSION shr 8 and $ff;
    MICRO:= VERSION and $ff;
    writeln(format('LIB_SWSCALE:    %s.dll     %s', [LIB_SWSCALE, AV_VERSION(MAJOR, MINOR, MICRO)]));

    readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
