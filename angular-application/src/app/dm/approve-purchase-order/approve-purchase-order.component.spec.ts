import { ComponentFixture, TestBed } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { ApprovePurchaseOrderComponent } from './approve-purchase-order.component';

describe('ApprovePurchaseOrderComponent', () => {
  let component: ApprovePurchaseOrderComponent;
  let fixture: ComponentFixture<ApprovePurchaseOrderComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ApprovePurchaseOrderComponent ],
      imports: [TestingModules, RouterTestingModule]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ApprovePurchaseOrderComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
