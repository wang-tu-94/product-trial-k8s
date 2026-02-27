# 🚀 Product Trial K8s

Ce dépôt contient les manifestes nécessaires pour déployer l'application **Product Trial** sur un cluster **Kubernetes**. 

## 📋 Table des matières
- [Prérequis](#-prérequis)
- [Architecture](#-architecture)
- [Installation et Déploiement](#-installation-et-déploiement)
- [Commandes utiles](#-commandes-utiles)

---

## 🛠 Prérequis

Avant de lancer le déploiement, assurez-vous de disposer des outils suivants :
- **Docker** installé sur votre machine.
- **Kubectl** configuré pour interagir avec votre cluster.
- Un cluster Kubernetes fonctionnel (ex: **Minikube**, **Kind**, ou un cluster distant).

---

## 🏗 Architecture

Le projet est divisé en plusieurs composants orchestrés par Kubernetes :
- **Frontend** : Interface utilisateur (Deployment + Service).
- **Backend API** : Logique métier et endpoints (Deployment + Service).
- **Base de données** : Persistance des données (Volume persistant + Deployment).

---

## 🚀 Installation et Déploiement

### 1. Cloner le dépôt
```bash
git clone [https://github.com/wang-tu-94/product-trial-k8s.git](https://github.com/wang-tu-94/product-trial-k8s.git)
cd product-trial-k8s
```

### 2. Déployer les ressources Kubernetes
Appliquez l'ensemble des manifestes présents dans le dossier `k8s/` :
```bash
kubectl apply -f k8s/
```

### 3. Vérifier le déploiement
Assurez-vous que tous les pods sont opérationnels (statut `Running`) :
```bash
kubectl get pods
```

Vérifiez également que les services sont bien exposés :
```bash
kubectl get svc
```

### 4. Accéder à l'application (si utilisation locale)
Si vous utilisez Minikube, vous pouvez exposer le service frontend avec cette commande :
```bash
minikube service <nom-du-service-frontend>
```

---

## 🔍 Commandes utiles

**Voir les logs d'un composant (ex: backend) :**
```bash
kubectl logs -f deployment/<nom-du-deployment-backend>
```

**Nettoyer et supprimer toutes les ressources créées :**
```bash
kubectl delete -f k8s/
```

---
*Maintenu par [wang-tu-94](https://github.com/wang-tu-94)*
