#FROM python:3.10.6
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

WORKDIR /subsai

COPY requirements.txt .

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git && \
    apt-get install -y gcc mono-mcs ffmpeg && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

COPY pyproject.toml .
COPY ./src ./src
COPY ./assets ./assets

RUN pip install .

EXPOSE 8501

ENTRYPOINT ["python", "src/subsai/webui.py", "--server.fileWatcherType", "none", "--browser.gatherUsageStats", "false"]

