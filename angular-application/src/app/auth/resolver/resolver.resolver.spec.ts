import { TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { ResolverResolver } from './resolver.resolver';

describe('ResolverResolver', () => {
  let resolver: ResolverResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TestingModules]
    });
    resolver = TestBed.inject(ResolverResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
