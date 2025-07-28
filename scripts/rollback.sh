#!/bin/bash

echo "=== KUBERNETES ROLLBACK DEMONSTRATION ==="

echo "1. Current backend deployment status:"
kubectl get deployments -n backend
kubectl rollout history deployment/backend-deployment -n backend
echo ""

echo "2. Performing a test update to demonstrate rollback..."
echo "Updating backend image to trigger a new revision..."
kubectl set image deployment/backend-deployment backend=node:18-alpine -n backend

echo "Waiting for rollout to complete..."
kubectl rollout status deployment/backend-deployment -n backend
echo ""

echo "3. New rollout history:"
kubectl rollout history deployment/backend-deployment -n backend
echo ""

echo "4. Rolling back to previous version..."
kubectl rollout undo deployment/backend-deployment -n backend

echo "Waiting for rollback to complete..."
kubectl rollout status deployment/backend-deployment -n backend
echo ""

echo "5. Rollback completed! Current status:"
kubectl get deployments -n backend
kubectl rollout history deployment/backend-deployment -n backend
echo ""

echo "6. Verifying pods are running with rolled-back version:"
kubectl get pods -n backend -o wide
echo ""

echo "7. HPA status after rollback:"
kubectl get hpa -n backend
echo ""

echo "=== ROLLBACK COMPLETED SUCCESSFULLY ==="
echo ""
echo "Additional rollback commands you can use:"
echo "- Rollback to specific revision: kubectl rollout undo deployment/backend-deployment --to-revision=X -n backend"
echo "- Pause rollout: kubectl rollout pause deployment/backend-deployment -n backend"
echo "- Resume rollout: kubectl rollout resume deployment/backend-deployment -n backend"
echo "- Check detailed rollout status: kubectl describe deployment backend-deployment -n backend"