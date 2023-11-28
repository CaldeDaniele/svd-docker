FROM ubuntu:latest

RUN apt-get update && apt-get install -y git python3.10 python3.10-venv

RUN git clone https://github.com/Stability-AI/generative-models.git
WORKDIR /generative-models

RUN python3 -m venv .pt2
RUN /bin/bash -c "source .pt2/bin/activate && pip3 install -r requirements/pt2.txt"
RUN /bin/bash -c "source .pt2/bin/activate && pip3 install ."
RUN /bin/bash -c "source .pt2/bin/activate && pip3 install -e git+https://github.com/Stability-AI/datapipelines.git@main#egg=sdata"
RUN /bin/bash -c "source .pt2/bin/activate && pip install streamlit"

COPY checkpoints/sd_xl_refiner_1.0.safetensors /generative-models/checkpoints/
COPY checkpoints/sd_xl_base_1.0.safetensors /generative-models/checkpoints/

EXPOSE 18091

CMD ["streamlit", "run", "scripts/demo/sampling.py", "--server.port=18091"]
