#!/bin/bash

echo "=== HPA TESTING SCRIPT ==="

echo "1. Current HPA status:"
kubectl get hpa --all-namespaces
echo ""

echo "2. Current pod counts:"
kubectl get pods --all-namespaces | grep -E "(frontend|backend)"
echo ""

echo "3. Starting load test for frontend..."
kubectl run load-test-frontend --image=busybox --restart=Never --rm -i --tty -- /bin/sh -c "
echo 'Starting load test on frontend...'
for i in \$(seq 1 1000); do
  wget -q -O- http://frontend-service.frontend.svc.cluster.local/ > /dev/null 2>&1 &
done
echo 'Load test completed'
sleep 60
"

echo ""
echo "4. Starting load test for backend..."
kubectl run load-test-backend --image=busybox --restart=Never --rm -i --tty -- /bin/sh -c "
echo 'Starting load test on backend...'
for i in \$(seq 1 1000); do
  wget -q -O- http://backend-service.backend.svc.cluster.local:3000/ > /dev/null 2>&1 &
done
echo 'Load test completed'
sleep 60
"

echo ""
echo "5. Monitoring HPA scaling (watch for 2 minutes)..."
echo "Press Ctrl+C to stop monitoring"

timeout 120s watch -n 5 'echo "=== HPA STATUS ===" && kubectl get hpa --all-namespaces && echo "=== POD COUNT ===" && kubectl get pods --all-namespaces | grep -E "(frontend|backend)" | wc -l && echo "=== RESOURCE USAGE ===" && kubectl top pods --all-namespaces | grep -E "(frontend|backend)"'

echo ""
echo "6. Final HPA status:"
kubectl get hpa --all-namespaces
echo ""
echo "7. Final pod counts:"
kubectl get pods --all-namespaces | grep -E "(frontend|backend)"
echo ""
echo "=== HPA TEST COMPLETED ==="