import SwiftUI
import SwiftData

/// Allows the user to enter a known cortisol concentration from a saliva test
/// kit and apply it to refine the personal calibration curve.
struct CalibrationView: View {
    @EnvironmentObject private var bleManager: BLEManager
    @EnvironmentObject private var calibrationEngine: CalibrationEngine
    @EnvironmentObject private var readingStore: ReadingStore

    @State private var salivaResultText: String = ""
    @State private var isCalibrating: Bool = false
    @State private var showConfirmation: Bool = false
    @State private var showInstructions: Bool = false
    @State private var errorMessage: String?

    private var salivaResultNgMl: Float? {
        Float(salivaResultText)
    }

    private var canCalibrate: Bool {
        salivaResultNgMl != nil
        && bleManager.latestReading != nil
        && bleManager.isConnected
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerCard
                    inputSection
                    calibrateButton
                    historySection
                }
                .padding()
            }
            .navigationTitle("Calibrate")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showInstructions = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .sheet(isPresented: $showInstructions) {
                instructionsSheet
            }
            .alert("Calibration Saved", isPresented: $showConfirmation) {
                Button("OK") { }
            } message: {
                Text("Your personal calibration has been updated.")
            }
        }
    }

    // MARK: - Subviews

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Personal Calibration", systemImage: "slider.horizontal.3")
                .font(.headline)
                .foregroundStyle(.indigo)

            Text("Use a saliva cortisol test kit to enter your actual level. CortiPod will adjust its sensor model to match your individual biology.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Saliva Test Result")
                .font(.headline)

            HStack {
                TextField("e.g. 12.5", text: $salivaResultText)
                    .keyboardType(.decimalPad)
                    .font(.title2.weight(.semibold))
                    .textFieldStyle(.roundedBorder)

                Text("ng/mL")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            // Current sensor reading preview
            if let reading = bleManager.latestReading {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current sensor reading")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(String(format: "%.3f µA", reading.cortisolRawUA))
                            .font(.caption)
                            .monospacedDigit()
                    }
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
                .padding(10)
                .background(Color.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            } else {
                Label(
                    bleManager.isConnected
                        ? "Waiting for a sensor reading…"
                        : "Connect your CortiPod device first",
                    systemImage: bleManager.isConnected ? "waveform" : "sensor.tag.radiowaves.forward.fill"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var calibrateButton: some View {
        Button {
            applyCalibration()
        } label: {
            Group {
                if isCalibrating {
                    ProgressView()
                        .tint(.white)
                } else {
                    Label("Apply Calibration", systemImage: "checkmark.circle.fill")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(.indigo)
        .disabled(!canCalibrate || isCalibrating)
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Calibration Tips")
                .font(.headline)

            tipRow(
                icon: "clock.fill",
                color: .blue,
                text: "Best taken in the morning (8–9 AM) when cortisol is naturally highest."
            )
            tipRow(
                icon: "drop.fill",
                color: .teal,
                text: "Avoid eating or drinking 30 minutes before the saliva test."
            )
            tipRow(
                icon: "arrow.triangle.2.circlepath",
                color: .indigo,
                text: "Repeat calibration every 2–4 weeks for best accuracy."
            )
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func tipRow(icon: String, color: Color, text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var instructionsSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("How to Calibrate")
                        .font(.title2.weight(.bold))

                    Text("1. Purchase a saliva cortisol test kit from a pharmacy or online.\n\n2. Follow the kit instructions exactly.\n\n3. While wearing CortiPod and after receiving your result, come back here and enter the ng/mL value.\n\n4. Tap **Apply Calibration**. CortiPod will immediately start accounting for your personal cortisol profile.")
                        .font(.body)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showInstructions = false }
                }
            }
        }
    }

    // MARK: - Actions

    private func applyCalibration() {
        guard
            let ngMl = salivaResultNgMl,
            let reading = bleManager.latestReading
        else { return }

        isCalibrating = true
        errorMessage = nil

        calibrationEngine.addCalibrationPoint(rawUA: reading.cortisolRawUA, knownConcentration: ngMl)
        calibrationEngine.recalibrate()

        // Persist the updated profile
        try? readingStore.save(profile: calibrationEngine.profile)

        isCalibrating = false
        salivaResultText = ""
        showConfirmation = true
    }
}

#Preview {
    let container = try! ModelContainer(
        for: SensorReading.self, CalibrationProfile.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let profile = CalibrationProfile(slope: 2.5, intercept: 1.0, baseline: 0.2)
    let store = ReadingStore(modelContext: ModelContext(container))
    let engine = CalibrationEngine(profile: profile)
    return CalibrationView()
        .environmentObject(BLEManager())
        .environmentObject(engine)
        .environmentObject(store)
        .modelContainer(container)
}
