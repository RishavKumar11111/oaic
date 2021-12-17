import { TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { CsrfInterceptor } from './csrf.interceptor';

describe('CsrfInterceptor', () => {
  beforeEach(() => TestBed.configureTestingModule({
    providers: [
      CsrfInterceptor
      ],
      imports: [TestingModules]
  }));

  it('should be created', () => {
    const interceptor: CsrfInterceptor = TestBed.inject(CsrfInterceptor);
    expect(interceptor).toBeTruthy();
  });
});
