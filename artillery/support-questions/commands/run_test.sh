#!/bin/bash

# Artillery CSV Load Test Runner
# Usage: ./run_test.sh [basic|advanced] [environment]

set -e

# Default values
TEST_TYPE=${1:-"basic"}
ENVIRONMENT=${2:-"local"}

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starting Artillery CSV Load Test${NC}"
echo -e "${YELLOW}Test Type: ${TEST_TYPE}${NC}"
echo -e "${YELLOW}Environment: ${ENVIRONMENT}${NC}"

# Set environment-specific variables
case $ENVIRONMENT in
    "local")
        export API_BASE_URL="http://localhost:3000"
        export ACCESS_TOKEN="demo-token"
        ;;
    "staging")
        export API_BASE_URL="https://staging-api.example.com"
        export ACCESS_TOKEN="${STAGING_ACCESS_TOKEN}"
        ;;
    "production")
        echo -e "${RED}⚠️  WARNING: Running against production!${NC}"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Test cancelled."
            exit 1
        fi
        export API_BASE_URL="https://api.example.com"
        export ACCESS_TOKEN="${PROD_ACCESS_TOKEN}"
        ;;
    *)
        echo -e "${RED}❌ Unknown environment: ${ENVIRONMENT}${NC}"
        echo "Available environments: local, staging, production"
        exit 1
        ;;
esac

# Check if CSV files exist
if [ ! -f "./data/questions.csv" ]; then
    echo -e "${RED}❌ CSV file not found: ./data/questions.csv${NC}"
    exit 1
fi

echo -e "${GREEN}✅ CSV files found${NC}"

# Choose test file
case $TEST_TYPE in
    "basic")
        TEST_FILE="create_question.yml"
        ;;
    "advanced")
        TEST_FILE="create_question_advanced.yml"
        if [ ! -f "./data/users.csv" ]; then
            echo -e "${RED}❌ CSV file not found: ./data/users.csv${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}❌ Unknown test type: ${TEST_TYPE}${NC}"
        echo "Available test types: basic, advanced"
        exit 1
        ;;
esac

echo -e "${GREEN}📊 Running Artillery test: ${TEST_FILE}${NC}"
echo -e "${YELLOW}Target: ${API_BASE_URL}${NC}"

# Run the test
artillery run "$TEST_FILE" --output "results/test-$(date +%Y%m%d-%H%M%S).json"

echo -e "${GREEN}✅ Test completed!${NC}"

# Generate HTML report if artillery-plugin-html-report is available
if command -v artillery &> /dev/null; then
    echo -e "${YELLOW}📈 Generating HTML report...${NC}"
    # Note: This requires artillery-plugin-html-report to be installed
    # npm install -g artillery-plugin-html-report
fi
