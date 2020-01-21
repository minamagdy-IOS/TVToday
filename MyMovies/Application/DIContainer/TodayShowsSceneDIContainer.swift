//
//  TVShowsSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class TodayShowsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeAiringTodayViewController() -> UIViewController {
        return AiringTodayViewController.create( with: makeAiringTodayViewModel(),
                                                 airingTodayViewControllersFactory: self)
    }
}

// MARK: - Private

extension TodayShowsSceneDIContainer {
    
    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes
    
    private func makeAiringTodayViewModel() -> AiringTodayViewModel {
        return AiringTodayViewModel(fetchTVShowsUseCase: makeFetchTodayShowsUseCase(),
                                    posterImageRepository: makePosterImageRepository())
    }
    
    // MARK: - Use Cases
    
    private func makeFetchTodayShowsUseCase() -> FetchTVShowsUseCase {
        return DefaultFetchTVShowsUseCase(tvShowsRepository: makeTVShowsRepository())
    }
    
    // MARK: - Repositories
    
    private func makeTVShowsRepository() -> TVShowsRepository {
        return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    private func makePosterImageRepository() -> PosterImageRepository {
        return DefaultPosterImageRepository(dataTransferService: dependencies.imageDataTransferService,
                                            imageNotFoundData: UIImage(named: "placeholder")?.pngData() )
    }
}

// MARK: - AiringTodayViewControllersFactory

extension TodayShowsSceneDIContainer: AiringTodayViewControllersFactory {
     
    public func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController {
        let showDetailsDependencies = TVShowDetailsSceneDIContainer.Dependencies(
                apiDataTransferService: dependencies.apiDataTransferService,
                imageDataTransferService: dependencies.imageDataTransferService)
            
        let container =  TVShowDetailsSceneDIContainer(dependencies: showDetailsDependencies)
        
        return container.makeTVShowDetailsViewController(with: identifier)
    }
}