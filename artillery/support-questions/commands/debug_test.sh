#!/bin/bash

echo "=== Artillery Load Test Debug Script ==="
echo "Current directory: $(pwd)"
echo "Date: $(date)"
echo ""

# Check if environment variables are set
echo "=== Environment Variables Check ==="
if [ -z "$ACCESS_TOKEN" ]; then
    echo "❌ ACCESS_TOKEN is not set"
else
    echo "✅ ACCESS_TOKEN is set (length: ${#ACCESS_TOKEN} characters)"
fi

if [ -z "$MONGO_CLAIMS" ]; then
    echo "❌ MONGO_CLAIMS is not set"
else
    echo "✅ MONGO_CLAIMS is set (length: ${#MONGO_CLAIMS} characters)"
fi
echo ""

# Check if CSV files exist
echo "=== CSV Files Check ==="
CSV_FILES=(
    "../../data/tst-questions-mongo.csv"
    "../../data/acc-questions-mongo-1k.csv"
    "../../data/acc-learning-support-centers.csv"
)

for file in "${CSV_FILES[@]}"; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file")
        echo "✅ $file exists ($lines lines)"
    else
        echo "❌ $file not found"
    fi
done
echo ""

# Check network connectivity
echo "=== Network Connectivity Check ==="
echo "Testing connection to target servers..."

TARGETS=(
    "https://lemonade.leersteun.lars-acc.school"
    "https://lemonade.leersteun.lars-tst.school"
)

for target in "${TARGETS[@]}"; do
    echo -n "Testing $target... "
    if curl -s --connect-timeout 10 --max-time 30 "$target" > /dev/null 2>&1; then
        echo "✅ Reachable"
    else
        echo "❌ Not reachable or timeout"
    fi
done
echo ""

# Run a simple test with low load
echo "=== Running Simple Test (1 request) ==="
echo "Running Artillery test with minimal load..."
artillery run create_question.yml --environment tst --count 1

echo ""
echo "=== Debug Complete ==="
