#!/bin/bash

echo "=== KUBERNETES SCALING DEMONSTRATION ==="

echo "Current status before scaling:"
kubectl get deployments --all-namespaces
kubectl get hpa --all-namespaces
echo ""

echo "1. Manual scaling applications..."

# Scale frontend manually
echo "Scaling frontend to 5 replicas..."
kubectl scale deployment frontend-deployment --replicas=5 -n frontend

# Scale backend manually
echo "Scaling backend to 4 replicas..."
kubectl scale deployment backend-deployment --replicas=4 -n backend

echo "Manual scaling completed!"
echo ""

echo "2. Current status after manual scaling:"
kubectl get deployments --all-namespaces
kubectl get pods --all-namespaces | grep -E "(frontend|backend)"
echo ""

echo "3. HPA Status (will override manual scaling based on metrics):"
kubectl get hpa --all-namespaces
echo ""

echo "4. Generating load to trigger HPA scaling..."
echo "Creating load generator pod..."

# Create a simple load generator
kubectl run load-generator --rm -i --tty --image=busybox --restart=Never -- /bin/sh -c "
echo 'Generating load on frontend service...'
while true; do
  wget -q -O- http://frontend-service.frontend.svc.cluster.local/ > /dev/null 2>&1
  sleep 0.1
done"

echo ""
echo "5. Monitor HPA scaling in real-time:"
echo "Run the following command to watch HPA scaling:"
echo "watch 'kubectl get hpa --all-namespaces && echo && kubectl get pods --all-namespaces | grep -E \"(frontend|backend)\"'"
echo ""
echo "6. To stop load generation, delete the load generator pod:"
echo "kubectl delete pod load-generator --ignore-not-found=true"