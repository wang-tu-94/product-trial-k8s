# ☸️ Product Trial - Kubernetes Infrastructure

<div align="center">
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes" />
  <img src="https://img.shields.io/badge/Kustomize-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kustomize" />
  <img src="https://img.shields.io/badge/Minikube-326CE5?style=for-the-badge&logo=minikube&logoColor=white" alt="Minikube" />
  <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
</div>

<br />

Ce dépôt centralise toute la configuration d'infrastructure de l'écosystème **Product Trial**. Il utilise les manifestes Kubernetes et **Kustomize** pour orchestrer le déploiement de l'ensemble des microservices, des bases de données et des brokers de messages, en séparant proprement les environnements (Local vs Production).

## 📋 Table des matières
- [Architecture Déployée](#-architecture-déployée)
- [Structure du Projet (Kustomize)](#-structure-du-projet-kustomize)
- [Prérequis](#-prérequis)
- [Déploiement Local](#-déploiement-local)
- [Commandes Utiles](#-commandes-utiles)
- [Nettoyage](#-nettoyage)

---

## 🏗 Architecture Déployée

Le cluster Kubernetes héberge les composants suivants :

**Microservices Applicatifs :**
- `app-front-angular` : L'interface utilisateur Web (Angular/Nginx).
- `api-gateway` : Le point d'entrée unique et filtre de sécurité (Spring Cloud Gateway).
- `ms-auth` : Microservice de gestion des identités et tokens JWT.
- `ms-products` : API principale gérant le catalogue et les paniers.
- `log-ingestor` : Service gRPC collectant les logs transverses.

**Infrastructure (Overlay Local) :**
- `postgres` : Base de données relationnelle pour le backend et l'auth.
- `kafka` & `kafka-ui` : Broker de messages pour le traitement asynchrone des logs.
- `ingress-nginx` : Contrôleur de routage pour exposer la Gateway et le Frontend.

---

## 📂 Structure du Projet (Kustomize)

Le projet suit la structure standard de Kustomize pour une configuration "DRY" (Don't Repeat Yourself) :

```text
k8s/
├── base/                   # Ressources communes à tous les environnements
│   ├── api-gateway-* # Déploiements, Services, ConfigMaps, Secrets
│   ├── ms-auth-* │   ├── ms-products-* │   ├── app-front-angular-* │   └── log-ingestor-* └── overlays/
    ├── local/              # Surcharge pour l'environnement de Dev (Minikube)
    │   ├── kafka-local.yml
    │   ├── postgres-local.yml
    │   └── *-patch.yml     # Patches pour les variables d'environnement locales
    └── production/         # Surcharge pour l'environnement de Prod (Cloud)
        └── *-patch.yml     # Patches pour les ressources, replicas et secrets de prod
```

---

## 🛠 Prérequis

Pour déployer l'infrastructure localement, vous devez installer :
- **Docker**
- **Minikube** (ou Kind)
- **kubectl** (avec le support de Kustomize intégré, version >= 1.14)

---

## 🚀 Déploiement Local

### 1. Cloner le projet
```bash
git clone [https://github.com/wang-tu-94/product-trial-k8s.git](https://github.com/wang-tu-94/product-trial-k8s.git)
cd product-trial-k8s
```

### 2. Démarrer Minikube
Un script utilitaire est fourni pour initialiser Minikube avec les bons addons (notamment Ingress) :
```bash
sh scripts/start-minikube.sh
```

### 3. Appliquer la configuration Kustomize (Environnement Local)
Utilisez l'option `-k` (Kustomize) au lieu de `-f` pour appliquer l'overlay local qui inclut automatiquement les bases de données et Kafka :
```bash
kubectl apply -k k8s/overlays/local
```

### 4. Configuration de l'accès (Hosts)
Afin que les règles d'Ingress fonctionnent (`my-project-app.local` par exemple), ajoutez l'IP de votre cluster Minikube à votre fichier `/etc/hosts` :
```bash
# Obtenir l'IP de Minikube
minikube ip

# Ajouter au fichier hosts (sudo requis)
# Exemple : 192.168.49.2 my-project-app.local api.my-project-app.local
```

---

## 🔍 Commandes Utiles

**Vérifier l'état de tous les pods :**
```bash
kubectl get pods -w
```

**Voir les logs d'un service spécifique (ex: API Gateway) :**
```bash
kubectl logs -f deployment/api-gateway-deployment
```

**Accéder à Kafka UI (si déployé) :**
```bash
kubectl port-forward svc/kafka-ui-service 9000:8080
# Accessible sur http://localhost:9000
```

---

## 🧹 Nettoyage

Pour détruire proprement toutes les ressources créées dans l'environnement local :
```bash
kubectl delete -k k8s/overlays/local
```

Pour arrêter le cluster local :
```bash
minikube stop
```

---
*Maintenu par [wang-tu-94](https://github.com/wang-tu-94)*
