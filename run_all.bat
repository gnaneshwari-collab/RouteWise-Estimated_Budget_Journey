@echo off
echo ====================================================================
echo   RouteWise - Travel-Friendly Journeys Launcher
echo   Python + Java + MySQL + Interactive Web UI
echo ====================================================================
echo.
echo Starting Java 21 Backend Server in background...
start "RouteWise Java 21 Backend" cmd /c "backend-java\run_java_backend.bat"

echo Starting Python 3.11 Journey Estimation Engine...
start "RouteWise Python AI Engine" cmd /c "backend-python\run_python_backend.bat"

echo Starting RouteWise Frontend Dev Server...
cmd /c "npm run dev"
