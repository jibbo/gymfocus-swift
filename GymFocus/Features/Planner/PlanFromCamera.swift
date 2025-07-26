////
////  PlanFromCamera.swift
////  GymFocus
////
////  Created by Giovanni De Francesco on 26/07/25.
////
//
//import SwiftUI
//import Vision
//import UIKit
//
//struct PlanFromCamera: View {
//    @Environment(\.dismiss) var dismiss
//    @ObservedObject private var workoutViewModel: WorkoutViewModel
//    
//    @State private var scannedImages: [UIImage] = []
//    @State private var isShowingVNDocumentCameraView = false
//    @State private var recognizedText: String? = nil
//    @State private var isLoading: Bool = false
//    
//    init(_ workoutViewModel: WorkoutViewModel){
//        self.workoutViewModel = workoutViewModel
//    }
//    
//    var body: some View {
//        NavigationView {
//            Grid {
//                ForEach(scannedImages, id: \.self) { image in
//                    VStack {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 100, height: 100)
//                            .padding()
//                        Button("recognize"){
//                            ocr(image: image)
//                        }
//                    }
//                }
//                if(isLoading){
//                    ProgressView("Downloading...").tint(.white)
//                }
//            }
//            .sheet(isPresented: $isShowingVNDocumentCameraView) {
//                VNDocumentCameraViewControllerRepresentable(scanResult: $scannedImages)
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button(action: showVNDocumentCameraView) {
//                        Image(systemName: "document.badge.plus.fill")
//                    }
//                }
//            }
//        }
//    }
//    
//    fileprivate func geminiCall(){
//        Task{
//            // Request background execution time
//            var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
//            
//            backgroundTaskID = UIApplication.shared.beginBackgroundTask(withName: "API_Call") {
//                // This block is called if the background task expires
//                UIApplication.shared.endBackgroundTask(backgroundTaskID)
//                backgroundTaskID = .invalid
//            }
//            
//            DispatchQueue.main.async {
//                isLoading = true
//            }
//            
//            do {
//                let response = try await APIService.shared.generateContent(
//                    text: prompt,
//                    images: scannedImages,
//                    useInlineImages: false,
//                    apiKey: "AIzaSyDrZuu6XVThbkcb5ImS8vfoxg-DsAPRd30"
//                )
//                self.workoutViewModel.workoutPlanItem = WorkoutPlanItem(workoutPlan: WorkoutPlan.fromJSON(response) ?? WorkoutPlan())
//                DispatchQueue.main.async {
//                    recognizedText = response
//                    isLoading = false
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    isLoading = false
//                }
//                print("API call failed: \(error)")
//            }
//            
//            // End background task
//            if backgroundTaskID != .invalid {
//                UIApplication.shared.endBackgroundTask(backgroundTaskID)
//                backgroundTaskID = .invalid
//            }
//        }
//    }
//    private func ocr(image: UIImage?) {
//        
//        if let cgImage = image?.cgImage {
//            
//            // Request handler
//            let handler = VNImageRequestHandler(cgImage: cgImage)
//            
//            let recognizeRequest = VNRecognizeTextRequest { (request, error) in
//                
//                // Parse the results as text
//                guard let result = request.results as? [VNRecognizedTextObservation] else {
//                    return
//                }
//                
//                // Extract the data
//                let stringArray = result.compactMap { result in
//                    result.topCandidates(1).first?.string
//                }
//                
//                // Update the UI
//                DispatchQueue.main.async {
//                    recognizedText = stringArray.joined(separator: "\n")
//                }
//            }
//            
//            // Process the request
//            recognizeRequest.recognitionLevel = .accurate
//            do {
//                try handler.perform([recognizeRequest])
//            } catch {
//                print(error)
//            }
//            
//        }
//    }
//    
//    
//    private var prompt = """
//    Read the pdf and return to me the workout plan with the following structure:
//    {"program":[{"name":"day 1","exercises":[{"name":"Squat"},{"name":"Chest flies"}],"weeks":[{"week":1,"sets":3,"reps":10,"weight_kg":50,"weight_percentage":"50%","notes":"Focus on form"},{"week":2,"sets":4,"reps":8,"weight_kg":52.5,"weight_percentage":"52.5%","notes":"Increase weight slightly"}]},{"name":"day 2","exercises":[{"name":"Leg extensions"},{"name":"Incliced chest press"}],"weeks":[{"week":1,"sets":3,"reps":10,"weight_kg":50,"weight_percentage":"50%","notes":"Focus on form"},{"week":2,"sets":4,"reps":8,"weight_kg":52.5,"weight_percentage":"52.5%","notes":"Increase weight slightly"}]}]}
//    """
//    
//    private func showVNDocumentCameraView() {
//        isShowingVNDocumentCameraView = true
//    }
//}
