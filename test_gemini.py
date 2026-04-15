import google.generativeai as genai

# Your API key
API_KEY = "Your_Api_key here"

# Configure
genai.configure(api_key=API_KEY)

# List all available models
print("Available models:")
for model in genai.list_models():
    print(f"- {model.name} (supports: {model.supported_generation_methods})")

# Test different models
test_models = [
    'models/gemini-1.5-pro',
    'models/gemini-1.5-flash',
    'models/gemini-pro',
    'gemini-1.5-pro',
    'gemini-1.5-flash',
]

print("\nTesting models:")
for model_name in test_models:
    try:
        model = genai.GenerativeModel(model_name)
        response = model.generate_content("Say 'hello' in one word")
        print(f"✅ {model_name}: {response.text[:20]}...")
    except Exception as e:
        print(f"❌ {model_name}: {str(e)[:50]}")
