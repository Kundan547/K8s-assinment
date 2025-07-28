#!/bin/bash

echo "Deploying Kubernetes Application..."

# Create namespaces
echo "Creating namespaces..."
kubectl apply -f namespace/

# Deploy database first
echo "Deploying database..."
kubectl apply -f database/

# Wait for database to be ready
echo "Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n database --timeout=300s

# Deploy backend
echo "Deploying backend..."
kubectl apply -f backend/

# Wait for backend to be ready
echo "Waiting for backend to be ready..."
kubectl wait --for=condition=ready pod -l app=backend -n backend --timeout=300s

# Deploy frontend
echo "Deploying frontend..."
kubectl apply -f frontend/

# Wait for frontend to be ready
echo "Waiting for frontend to be ready..."
kubectl wait --for=condition=ready pod -l app=frontend -n frontend --timeout=300s

# Enable metrics server for HPA (if using minikube)
echo "Enabling metrics server..."
minikube addons enable metrics-server

# Wait for metrics server to be ready
echo "Waiting for metrics server to be ready..."
sleep 60

# Deploy HPA
echo "Deploying HPA..."
kubectl apply -f hpa/

# Wait a bit for HPA to initialize
echo "Waiting for HPA to initialize..."
sleep 30

echo "Deployment completed!"
echo "Access the application at: http://$(minikube ip):30080"

# Show comprehensive status
echo "=== DEPLOYMENT STATUS ==="
echo "Pods:"
kubectl get pods --all-namespaces
echo ""
echo "Services:"
kubectl get services --all-namespaces
echo ""
echo "HPA Status:"
kubectl get hpa --all-namespaces
echo ""
echo "Deployments:"
kubectl get deployments --all-namespaces