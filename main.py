from ultralytics import YOLO
import cv2
import time
import subprocess
import sys
import os

if getattr(sys, 'frozen', False):
    base_path = sys._MEIPASS
else:
    base_path = os.path.dirname(__file__)

def main():
    model_path = os.path.join(base_path, 'yolov8n.pt')
    video_path = os.path.join(base_path, 'Indiana_Jones.mp4')
    
    model = YOLO(model_path)
    webcam = cv2.VideoCapture(1)
    
    if not webcam.isOpened():
        raise ValueError("Impossible d'ouvrir la webcam")
    
    print("🎥 Webcam démarrée - appuie sur 'q' pour quitter")
    print("📱 Détection doomscroll activée...")
    
    vlc_process = None
    doomscroll_mode = False
    last_phone_seen = 0
    phone_threshold = 1.5
    
    class_names = model.names
    
    # Crée la fenêtre avec un titre explicite
    cv2.namedWindow('YOLO Detection - Appuie sur Q pour quitter', cv2.WINDOW_NORMAL)
    
    try:
        while True:
            ret, frame = webcam.read()
            if not ret:
                print("❌ Erreur lecture frame")
                break
            
            results = model(frame, verbose=False, classes=[0, 67])
            
            phone_detected = False
            for box in results[0].boxes:
                if int(box.cls[0]) == 67:
                    phone_detected = True
                    break
            
            if phone_detected:
                last_phone_seen = time.time()
                
                if not doomscroll_mode:
                    print("🚨 DOOMSCROLL DÉTECTÉ!")
                    doomscroll_mode = True
                    vlc_process = subprocess.Popen(
                        ['/Applications/VLC.app/Contents/MacOS/VLC', 
                         '--fullscreen', 
                         '--loop', 
                         video_path],
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL
                    )
            else:
                if doomscroll_mode and time.time() - last_phone_seen > phone_threshold:
                    print("✅ Téléphone disparu - Fermeture vidéo")
                    doomscroll_mode = False
                    if vlc_process:
                        vlc_process.terminate()
                        vlc_process = None
            
            annotated_frame = results[0].plot()
            
            # Status en haut
            status = "🔴 DOOMSCROLL MODE" if doomscroll_mode else "🟢 CLEAN"
            color = (0, 0, 255) if doomscroll_mode else (0, 255, 0)
            cv2.putText(annotated_frame, status, (10, 40), 
                       cv2.FONT_HERSHEY_SIMPLEX, 1.2, color, 3)
            
            # Instruction en bas
            height = annotated_frame.shape[0]
            cv2.putText(annotated_frame, "Appuie sur 'Q' pour quitter", (10, height - 20), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)
            
            cv2.imshow('YOLO Detection - Appuie sur Q pour quitter', annotated_frame)
            
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q') or key == ord('Q'):
                break
                
    finally:
        if vlc_process:
            vlc_process.terminate()
        webcam.release()
        cv2.destroyAllWindows()
        print("✅ Fermé")

if __name__ == "__main__":
    main()