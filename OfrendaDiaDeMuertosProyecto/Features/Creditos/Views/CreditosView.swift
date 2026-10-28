//
//  CreditosView.swift
//  OfrendaDiaDeMuertosProyecto
//
//  Created by Adolfo G on 16/10/26.
//

import SwiftUI

struct CreditosView: View {
    let onVerGuia: () -> Void
    private let integrantes = [
        "Adolfo de Jesus Garcia Cortes",
        "Victor Jaziel Flores Colin",
        "Angel Husiel Lara Hernandez",
        "Rodrigo Lugo Manzano"
    ]
    @State private var toques: Int = 0
    @State private var Easteregg: Bool = false

    var body: some View {
        ZStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Creditos").font(.largeTitle.bold()).accessibilityAddTraits(.isHeader)
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Array(integrantes.enumerated()), id: \.offset) { indice, nombre in
                            Text(nombre).font(.title3.weight(.semibold))
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .onTapGesture{
                                    if nombre == integrantes[1] {
                                        toques += 1
                                        if toques == 7 {
                                            withAnimation(.spring()){
                                                Easteregg = true
                                            }
                                            toques = 0
                                        }
                                    }else {
                                        toques = 0
                                    }
                                }
                            if indice < integrantes.count - 1 { Divider().overlay(AppTheme.secondaryText.opacity(0.25)) }
                        }
                    }
                    Button("Volver a ver la guía", systemImage: "questionmark.circle") {
                        onVerGuia()
                    }
                        .ofrendaSecondaryAction()
                        .frame(minHeight: 44)
                        .accessibilityIdentifier("creditos.verGuia")
                    
                    Spacer()
                    
                    Text("Hecho en el iOS Development Lab.")
                        .font(.body.weight(.medium)).foregroundStyle(AppTheme.accent)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 300)
                }
                .frame(maxWidth: 600, alignment: .leading)
                .padding(24).frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundStyle(.white)
            .background(AppTheme.background.ignoresSafeArea())
            
            if Easteregg {
                ZStack{
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation{Easteregg = false}
                        }
                    ConfettiView()
                        .ignoresSafeArea()
                    Image("image2")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                        .cornerRadius(16)
                        .shadow(radius: 29)
                        .transition(.scale.combined(with: .opacity))
                }
                .zIndex(1)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 7.0 ){
                        withAnimation{
                            Easteregg = false
                        }
                    }
                }
                .onTapGesture {
                    withAnimation{
                        Easteregg = false
                    }
                }
                
            }
        }
    }
}

#Preview {
    CreditosView(onVerGuia: {})
}
