# Must use a Cuda version 11+
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

WORKDIR /

# Install git and wget
RUN apt-get update && apt-get install --no-install-recommends -y git wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Clone the transformers repository
RUN git clone https://github.com/huggingface/transformers.git

# Change to the transformers directory and install it
WORKDIR transformers
RUN pip install -e .

WORKDIR /

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Add your model weight files 
COPY download.py .
RUN python3 download.py

COPY . .

EXPOSE 8000

CMD python3 -u app.py
