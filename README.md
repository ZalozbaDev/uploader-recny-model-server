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

### whisper (powšitkowny)

#### model wobstarać a přihotować

```code
mkdir -p tmp && cd tmp

git clone git@github.com:ggerganov/whisper.cpp.git

git checkout v1.5.4

git clone https://huggingface.co/spaces/Korla/hsb_stt_demo

git clone https://github.com/openai/whisper

cd whisper.cpp/

mkdir -p output/hsb/whisper_small

python3 ./models/convert-h5-to-ggml.py  ../hsb_stt_demo/hsb_whisper/ ../whisper/ output/hsb/whisper_small

cd ../../
```

#### model do rjadowaka kopěrować

```code
mkdir -p whisper/hsb/whisper_small/

cp tmp/whisper.cpp/output/hsb/whisper_small/* whisper/hsb/whisper_small/
```

### fairseqdata

```code
cd fairseqdata

wget https://dl.fbaipublicfiles.com/mms/asr/mms1b_all.pt
```

### whisper (europeada 2022)

```code
mkdir -p tmp && cd tmp

git clone git@github.com:ggerganov/whisper.cpp.git

git clone https://huggingface.co/danielzoba/whisper_small_adapted_2024_06_03

git clone https://github.com/openai/whisper

cd whisper.cpp/

git checkout v1.5.4

mkdir -p output/hsb/whisper_small_europeada

mkdir -p ggml_out

cp ../whisper_small_adapted_2024_06_03/0015_even_more_2024_recordings_0001/checkpoint-3800/* ggml_out/
cp ../whisper_small_adapted_2024_06_03/0015_even_more_2024_recordings_0001/vocab.json        ggml_out/
cp ../whisper_small_adapted_2024_06_03/0015_even_more_2024_recordings_0001/added_tokens.json ggml_out/

python3 ./models/convert-h5-to-ggml.py ggml_out/ ../whisper output/hsb/whisper_small_europeada/

```

### whisper (wulki/Korla)

#### model wobstarać a přihotować

```code
mkdir -p tmp && cd tmp

git clone git@github.com:ggerganov/whisper.cpp.git

git clone https://huggingface.co/Korla/whisper-large-hsb

git clone https://github.com/openai/whisper

cd whisper.cpp/

mkdir -p output/hsb/whisper_large/

python3 ./models/convert-h5-to-ggml.py ../whisper-large-hsb/ ../whisper output/hsb/whisper_large/

cd ../../
```

### whisper (wulki/DILHTWD)

#### model wobstarać a přihotować

```code
mkdir -p tmp && cd tmp

git clone git@github.com:ggerganov/whisper.cpp.git

git clone https://huggingface.co/openai/whisper-large-v3

git clone https://huggingface.co/DILHTWD/whisper-large-v3-hsb

cp whisper-large-v3/vocab.json        whisper-large-v3-hsb
cp whisper-large-v3/added_tokens.json whisper-large-v3-hsb

git clone https://github.com/openai/whisper

cd whisper.cpp/

mkdir -p output/hsb/whisper_large_dilhtwd/

python3 ./models/convert-h5-to-ggml.py ../whisper-large-v3-hsb/ ../whisper output/hsb/whisper_large_dilhtwd/

cd ../../
```

## Container wuwjesć

Hlej dokumentacija hłownej aplikacije: [tule](https://github.com/ZalozbaDev/uploader-recny-model) 

# Licenca

Hlej dataja "LICENSE".

