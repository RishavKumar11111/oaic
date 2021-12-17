import { TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { LayoutService } from './layout.service';

describe('LayoutService', () => {
  let service: LayoutService;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TestingModules],
      providers: [LayoutService]
    });
    service = TestBed.inject(LayoutService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
