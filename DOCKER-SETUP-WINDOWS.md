# 🐳 Docker Desktop Setup Guide for Windows

## 🎯 **Complete Setup Checklist**

Your Windows 10 system needs these components for Docker Desktop to work properly:

### **✅ Step 1: Enable Virtualization in BIOS**
**Why needed:** Docker needs hardware virtualization to run containers

**How to check:**
1. Open **Task Manager** (Ctrl+Shift+Esc)
2. Go to **Performance** tab → **CPU**
3. Look for "**Virtualization: Enabled**"

**If DISABLED:**
1. **Restart your computer**
2. **Enter BIOS** (usually F2, F12, Del, or Esc during boot)
3. **Find:** Intel VT-x / AMD-V or "Virtualization Technology"
4. **Enable it**
5. **Save and Exit**

---

### **✅ Step 2: Enable Windows Features**
**Run PowerShell as Administrator** (Right-click → Run as Administrator)

#### **Enable WSL (Windows Subsystem for Linux):**
```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Enable Windows Hypervisor Platform (for better performance)
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart
```

#### **Alternative: Use Windows Features Dialog:**
1. Press **Win+R** → type `appwiz.cpl` → Enter
2. Click **"Turn Windows features on or off"**
3. **Check these boxes:**
   - ☑️ **Windows Subsystem for Linux**
   - ☑️ **Virtual Machine Platform**
   - ☑️ **Windows Hypervisor Platform** (if available)
4. **Click OK** and **restart** when prompted

---

### **✅ Step 3: Install WSL2 (Recommended)**

#### **Update WSL to version 2:**
```powershell
# Run in Admin PowerShell
wsl --set-default-version 2

# Update WSL kernel (if needed)
# Download from: https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
```

#### **Install a Linux Distribution (Optional but recommended):**
```powershell
# Install Ubuntu (lightweight)
wsl --install -d Ubuntu

# OR from Microsoft Store:
# Search "Ubuntu" or "Debian" and install
```

---

### **✅ Step 4: Install/Update Docker Desktop**

#### **Download Docker Desktop:**
1. Go to: **https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe**
2. **Run the installer**
3. **Check:** "Use WSL 2 instead of Hyper-V" (recommended)
4. **Complete installation**
5. **Restart computer**

#### **First Time Setup:**
1. **Start Docker Desktop**
2. **Accept terms**
3. **Skip Docker Hub sign-in** (optional)
4. **Wait for Docker to initialize** (green icon in system tray)

---

### **✅ Step 5: Configure Docker Desktop**

#### **Settings → General:**
- ☑️ **Use WSL 2 based engine**
- ☑️ **Start Docker Desktop when you log in**

#### **Settings → Resources:**
- **Memory:** At least 4GB (more is better)
- **CPU:** At least 2 cores
- **Disk:** At least 20GB free space

#### **Settings → Docker Engine (Advanced):**
```json
{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB"
    }
  }
}
```

---

### **✅ Step 6: Verify Installation**

#### **Test Docker is Working:**
```powershell
# Check Docker version
docker --version

# Test with hello world
docker run hello-world

# Check Docker Compose
docker-compose --version
```

**Expected Output:**
```
Docker version 24.0.x, build xxxxx
Hello from Docker!
Docker Compose version v2.x.x
```

---

## 🚨 **Common Issues & Solutions**

### **Issue 1: "WSL 2 installation is incomplete"**
**Solution:**
```powershell
# Run as Administrator
wsl --update
wsl --set-default-version 2
```

### **Issue 2: "Hardware assisted virtualization not available"**
**Solution:**
1. **Enable VT-x/AMD-V in BIOS** (see Step 1)
2. **Disable Hyper-V if conflicting:**
   ```powershell
   # Run as Administrator
   dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
   ```

### **Issue 3: "Docker daemon not running"**
**Solution:**
1. **Restart Docker Desktop**
2. **Check Windows Services:**
   - Press Win+R → `services.msc`
   - Find "Docker Desktop Service"
   - Right-click → Restart

### **Issue 4: Slow Performance**
**Solution:**
1. **Increase memory allocation** in Docker settings
2. **Move Docker data to SSD** if available
3. **Enable WSL 2** for better performance

---

## 🎯 **Step-by-Step Execution Plan**

### **Phase 1: System Preparation (10 minutes)**
1. **Check virtualization** in Task Manager
2. **Enable in BIOS** if needed (requires restart)
3. **Run PowerShell as Administrator**

### **Phase 2: Windows Features (5 minutes + restart)**
```powershell
# Run all these in Admin PowerShell
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart  
dism.exe /online /enable-feature /featurename:HypervisorPlatform /all /norestart

# Then restart computer
Restart-Computer
```

### **Phase 3: WSL Setup (5 minutes)**
```powershell
# After restart, run as Administrator
wsl --set-default-version 2
wsl --install -d Ubuntu  # Optional but recommended
```

### **Phase 4: Docker Installation (10 minutes)**
1. **Download** Docker Desktop installer
2. **Run installer** with WSL 2 option
3. **Restart computer**
4. **Start Docker Desktop**

### **Phase 5: Verification (2 minutes)**
```powershell
docker --version
docker run hello-world
```

---

## 🚀 **After Setup: Return to Your Project**

### **Once Docker is Working:**
```powershell
# Navigate to your project
cd C:\Users\Dell\Projects\ai-tools-reviewer

# Test your setup
docker-compose build

# Start your AI tools platform
docker-compose up -d
```

### **Expected Results:**
- **Frontend:** http://localhost:8000
- **Backend API:** http://localhost:3001
- **Database:** Running in container
- **Redis:** Running in container

---

## 💡 **Pro Tips**

### **Performance Optimization:**
- **Allocate 6-8GB RAM** to Docker if you have 16GB+ total
- **Use SSD** for Docker data directory
- **Close unnecessary programs** when developing

### **Troubleshooting:**
- **Check Docker Desktop logs** (Settings → Troubleshoot → Show logs)
- **Restart Docker Desktop** if containers won't start
- **Use WSL 2** for better performance than Hyper-V

### **Development Workflow:**
- **Start Docker Desktop** before development
- **Use docker-compose** for multi-container apps
- **Monitor resource usage** in Docker Desktop dashboard

---

## 🎯 **What to Do Now**

1. **Follow Phase 1-5** above step by step
2. **Test with hello-world** to verify setup
3. **Come back to me** when Docker is working
4. **We'll launch your AI tools platform** with full containerization

**This setup will make your development workflow much more professional and your platform much easier to deploy! 🚀**