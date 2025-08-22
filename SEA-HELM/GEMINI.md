# How to Install pyonmttok?

The repository SEA-HELM provides requirements.txt. And the following command

```shell
$ pip3 install -r requirements.txt
```

fails with the following error.

```shell
   ...
ERROR: Ignored the following versions that require a different python version: 0.1.0 Requires-Python <3.12,>=3.8
ERROR: Could not find a version that satisfies the requirement pyonmttok==1.37.1 (from versions: none)
ERROR: No matching distribution found for pyonmttok==1.37.1
$
```

The original requirements.txt failed with the following errors. 

| The original requirements.txt `bert-score==0.3.13 datasets==3.0.1 einops==0.8.0 evaluate==0.4.3 fast-langdetect==0.2.2 litellm==1.61.20 nltk==3.9.1 omegaconf==2.3.0 openai==1.64.0 pyonmttok==1.37.1 pythainlp==5.0.5 sacrebleu==2.4.3 scikit-learn==1.4.2 transformers==4.48.3`  Q: Downgrade the Python version? A: Doing so may cause additional issue with the recent versions of other tools like LiteLLM, OLLama, Gemini-CLI.  |
| :---- |

| Instead, try to use a new requirements.txt for the new versions. `# Core dependencies with flexible versioning for Python 3.13 compatibility bert-score datasets einops evaluate fast-langdetect litellm nltk omegaconf openai pythainlp sacrebleu scikit-learn transformers vllm openai-agents[litellm]  # Vertex AI dependencies for Gemini API google-cloud-aiplatform>=1.35.0 google-auth>=2.17.0 google-auth-oauthlib>=1.0.0 google-auth-httplib2>=0.1.0 vertexai>=1.35.0 google-genai>=0.3.0  # Optional dependencies (commented out if causing issues) # pyonmttok>=1.37.1  # May not be compatible with Python 3.13`  There is one problem left with the new requirements.txt. I wasn't able to install pyonmttok properly.  Note: The tokenizer package pyonmttok is missing. Manual installation attempts failed `$ sudo apt install -y build-essential cmake`  `$ pip install git+https://github.com/OpenNMT/Tokenizer.git`  `Collecting git+https://github.com/OpenNMT/Tokenizer.git   Cloning https://github.com/OpenNMT/Tokenizer.git to /tmp/pip-req-build-xnwtw34f   Running command git clone --filter=blob:none --quiet https://github.com/OpenNMT/Tokenizer.git /tmp/pip-req-build-xnwtw34f   Resolved https://github.com/OpenNMT/Tokenizer.git to commit 75117755d6c7a24d46509f867726e446be05317f   Running command git submodule update --init --recursive -q ERROR: git+https://github.com/OpenNMT/Tokenizer.git does not appear to be a Python project: neither 'setup.py' nor 'pyproject.toml' found. $`  What should I do to fix this problem and install pyonmttok successfully? |
| :---- |

