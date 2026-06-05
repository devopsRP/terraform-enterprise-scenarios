# Azure Storage Upload Notification System using Terraform

## Problem Statement

You and your team are working on a project in Microsoft Azure. Initially, infrastructure resources were created manually through the Azure Portal. As the project grew, managing multiple environments and recreating resources became increasingly difficult and error-prone.

To solve this challenge, the team decided to adopt **Terraform** as an Infrastructure as Code (IaC) tool. The goal is to automate the provisioning of Azure resources and establish an event-driven architecture that automatically notifies a Service Bus Queue whenever a new file is uploaded to Azure Blob Storage.

### Requirements

The solution should provision the following Azure resources:

1. An Azure Storage Account.
2. A Blob Storage Container for file uploads.
3. An Azure Service Bus Namespace.
4. An Azure Service Bus Queue.
5. An Event Grid Subscription that listens for blob upload events and forwards notifications to the Service Bus Queue.

---

# Solution Overview

The solution follows an event-driven architecture where Azure services automatically communicate with each other whenever a file is uploaded.

Instead of continuously checking for new files, Azure Event Grid detects upload events and delivers notifications to Azure Service Bus. Applications can then consume these notifications asynchronously for further processing.

This approach improves scalability, reliability, and maintainability while reducing custom code and infrastructure complexity.

---

# Architecture Workflow

The complete workflow is illustrated below:

```text
User Uploads File
        │
        ▼
Azure Blob Storage Container
        │
        ▼
BlobCreated Event Generated
        │
        ▼
Azure Event Grid
        │
        ▼
Azure Service Bus Queue
        │
        ▼
Consumer Application
```

### Step-by-Step Flow

#### Step 1: File Upload

A user uploads a file such as:

```text
invoice.pdf
```

to the Azure Blob Storage Container.

#### Step 2: Blob Created Event

As soon as the file is uploaded, Azure Storage automatically generates a:

```text
Microsoft.Storage.BlobCreated
```

event.

#### Step 3: Event Grid Processing

Azure Event Grid receives the event notification and determines which subscribers should receive it.

#### Step 4: Queue Notification

Event Grid forwards the event information to the configured Azure Service Bus Queue.

#### Step 5: Application Processing

A consumer application can read messages from the queue and perform actions such as:

* File validation
* Data extraction
* Virus scanning
* Image processing
* Workflow automation
* Notifications

---

# Resource Explanation

## 1. Resource Group

### Purpose

A Resource Group is a logical container that holds all related Azure resources.

### Why It Is Used

Managing all project resources inside a single Resource Group provides:

* Easier administration
* Simplified deployment
* Centralized monitoring
* Consistent access control

### Responsibility

Acts as the parent container for all infrastructure resources.

---

## 2. Storage Account

### Purpose

The Storage Account provides Azure's storage services and serves as the foundation for storing files and blobs.

### Why It Is Used

The application requires a location where users can upload files.

Without a Storage Account:

* Files cannot be stored.
* Blob Containers cannot exist.

### Responsibility

Stores all uploaded content and generates events when files are created.

### Key Benefit

Provides highly available and scalable cloud storage.

---

## 3. Storage Container

### Purpose

A Storage Container organizes blobs within a Storage Account.

### Why It Is Used

Files cannot be uploaded directly to a Storage Account. Azure requires a container to hold blob data.

### Responsibility

Acts as the upload destination for user files.

### Example

```text
Storage Account
│
└── upload-container
      ├── invoice.pdf
      ├── image.png
      └── report.docx
```

### Key Benefit

Provides logical separation and organization of stored files.

---

## 4. Service Bus Namespace

### Purpose

A Service Bus Namespace serves as a logical container for messaging resources such as queues and topics.

### Why It Is Used

Azure Service Bus Queues must be created inside a namespace.

Without a namespace:

* Queues cannot exist.

### Responsibility

Hosts and manages all messaging-related resources.

### Key Benefit

Provides a centralized messaging environment.

---

## 5. Service Bus Queue

### Purpose

A Service Bus Queue stores messages until they are processed by an application.

### Why It Is Used

Direct communication between Azure Storage and applications can create tight coupling.

The queue introduces asynchronous communication.

### Responsibility

Receives upload notifications and stores them until a consumer application processes them.

### Example Workflow

```text
File Uploaded
      │
      ▼
Event Received
      │
      ▼
Queue Stores Message
      │
      ▼
Application Processes Later
```

### Why Queue-Based Processing Is Important

* Decouples services
* Improves reliability
* Supports retry mechanisms
* Handles traffic spikes

### Key Benefit

Ensures messages are not lost even if downstream applications are temporarily unavailable.

---

## 6. Event Grid Subscription

### Purpose

Event Grid is Azure's event routing service.

An Event Grid Subscription defines which events should be monitored and where they should be delivered.

### Why It Is Used

The solution requires automatic notification whenever a file is uploaded.

Without Event Grid:

* Custom polling mechanisms would be required.
* Additional application logic would be needed.

### Responsibility

Monitors blob creation events and routes them to the Service Bus Queue.

### Event Being Monitored

```text
Microsoft.Storage.BlobCreated
```

### Key Benefit

Provides real-time event delivery with minimal infrastructure management.

---

# How Notifications Are Triggered

Whenever a file is uploaded to the Blob Storage Container:

1. Azure Storage generates a BlobCreated event.
2. Event Grid detects the event.
3. Event Grid forwards the event to the Service Bus Queue.
4. A consumer application reads the message from the queue.

This process is fully automatic and does not require manual intervention.

---

# Benefits of This Architecture

### Infrastructure as Code

Terraform enables consistent and repeatable deployments across multiple environments.

### Event-Driven Design

Resources communicate through events instead of direct dependencies.

### Scalability

Azure Storage, Event Grid, and Service Bus can scale independently.

### Reliability

Messages remain in the queue until successfully processed.

### Maintainability

Infrastructure can be recreated or modified through code rather than manual portal configuration.

### Reduced Operational Overhead

Azure managed services handle storage, messaging, and event routing automatically.

---

# Conclusion

This solution implements a scalable and event-driven Azure architecture using Terraform. Files uploaded to Azure Blob Storage automatically generate events that are routed through Event Grid and delivered to a Service Bus Queue. This design promotes loose coupling, reliability, scalability, and easier infrastructure management while following Infrastructure as Code best practices.
