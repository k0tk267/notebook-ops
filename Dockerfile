FROM python:3.8-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /app

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y \
    libgl1-mesa-dev \
    libopencv-dev \
    gcc \
    g++ \
    git

COPY poetry.lock pyproject.toml ./

RUN pip install poetry

RUN poetry config virtualenvs.create false \
  && poetry install
