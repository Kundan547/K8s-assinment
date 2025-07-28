#!/bin/bash

echo "=== CLEANING UP KUBERNETES RESOURCES ==="

echo "1. Deleting HPA..."
kubectl delete -f hpa/ --ignore-not-found=true

echo "2. Deleting application resources..."
kubectl delete -f frontend/ --ignore-not-found=true
kubectl delete -f backend/ --ignore-not-found=true
kubectl delete -f database/ --ignore-not-found=true

echo "3. Deleting namespaces (this will clean up everything)..."
kubectl delete -f namespace/ --ignore-not-found=true

echo "4. Deleting any remaining load test pods..."
kubectl delete pod load-generator --ignore-not-found=true
kubectl delete pod load-test-frontend --ignore-not-found=true
kubectl delete pod load-test-backend --ignore-not-found=true

echo "5. Waiting for cleanup to complete..."
sleep 30

echo "6. Verifying cleanup..."
kubectl get all --all-namespaces | grep -E "(frontend|backend|database)"

echo ""
echo "=== CLEANUP COMPLETED ==="
echo "If you want to stop minikube completely, run: minikube stop"
echo "To delete minikube cluster entirely, run: minikube delete"