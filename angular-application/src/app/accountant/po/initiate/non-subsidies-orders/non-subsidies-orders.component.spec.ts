import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { NonSubsidiesOrdersComponent } from './non-subsidies-orders.component';

describe('NonSubsidiesOrdersComponent', () => {
  let component: NonSubsidiesOrdersComponent;
  let fixture: ComponentFixture<NonSubsidiesOrdersComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NonSubsidiesOrdersComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NonSubsidiesOrdersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
