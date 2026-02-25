#!/bin/bash

echo "🚀 Démarrage de l'environnement local Minikube..."

# 1. Démarrer Minikube (si pas déjà lancé)
if minikube status | grep -q "Running"; then
    echo "✅ Minikube est déjà en cours d'exécution."
else
    minikube start --driver=docker --memory=4096 --cpus=4
fi

# 2. Activer l'addon Ingress
echo "🌐 Activation de l'addon Ingress..."
minikube addons enable ingress

echo "⏳ Attente du démarrage du contrôleur Ingress..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# 3. Appliquer la configuration Kubernetes (Kustomize)
# Cela va créer : Postgres, le Backend, le Frontend, les ConfigMaps et les Secrets locaux
echo "📦 Déploiement des manifests (Overlay: Local)..."
kubectl apply -k k8s/overlays/local

echo "⏳ Attente du démarrage des Pods..."
kubectl wait --for=condition=ready pod -l app=postgres --timeout=60s
kubectl wait --for=condition=ready pod -l app=kafka --timeout=120s
kubectl wait --for=condition=ready pod -l component=product-backend --timeout=60s
kubectl wait --for=condition=ready pod -l component=log-ingestor --timeout=60s
kubectl wait --for=condition=ready pod -l component=ms-auth --timeout=60s

# 4. Afficher l'IP pour accéder à l'app
IP=$(minikube ip)
echo "-------------------------------------------------------"
echo "🎉 Déploiement terminé !"
echo "📍 Adresse IP de Minikube : $IP"
echo "👉 Si tu as configuré un Ingress, ajoute cette ligne à ton fichier /etc/hosts :"
echo "$IP  product-app.local"
echo "-------------------------------------------------------"

# 5. Lancer le tunnel (nécessaire sur macOS/Windows pour l'Ingress)
echo "💡 Note: Le tunnel minikube va démarrer. Laisse ce terminal ouvert."
minikube tunnel