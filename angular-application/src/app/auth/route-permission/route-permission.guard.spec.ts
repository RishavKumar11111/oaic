import { TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { RoutePermissionGuard } from './route-permission.guard';

describe('RoutePermissionGuard', () => {
  let guard: RoutePermissionGuard;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [TestingModules]
    });
    guard = TestBed.inject(RoutePermissionGuard);
  });

  it('should be created', () => {
    expect(guard).toBeTruthy();
  });
});
