# Spóznawanje rěče - serwer

## Container(y) twarić

```code
docker build -f docker/Dockerfile.transcription -t offline_transcription_back .
docker build -f docker/Dockerfile.phonetics     -t phonetics_back .
```

## Přidatne dataje wobstarać

Wotpowědne rjadowaki wutworić

```code
mkdir -p proprietary whisper fairseqdata
```

### proprietary

Spóznawanski system wot Fraunhofer bohužel njeje zjawne přistupne.

### whisper

#### modele wobstarać a přihotować

https://github.com/ZalozbaDev/mudrowak/blob/main/doc/models/README.md

#### modele do rjadowaka kopěrować

```code
mkdir -p whisper/hsb/whisper_small/

cp TBD whisper/hsb/whisper_small/
...
TBD
```

### fairseqdata

```code
cd fairseqdata

wget https://dl.fbaipublicfiles.com/mms/asr/mms1b_all.pt
```

## Container wuwjesć

Hlej dokumentacija hłownej aplikacije: [tule](https://github.com/ZalozbaDev/uploader-recny-model) 

# Licenca

Hlej dataja "LICENSE".

