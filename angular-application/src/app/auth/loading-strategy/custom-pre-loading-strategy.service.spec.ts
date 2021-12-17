import { TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { CustomPreLoadingStrategyService } from './custom-pre-loading-strategy.service';

describe('CustomPreLoadingStrategyService', () => {
  let service: CustomPreLoadingStrategyService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TestingModules]
    });
    service = TestBed.inject(CustomPreLoadingStrategyService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
