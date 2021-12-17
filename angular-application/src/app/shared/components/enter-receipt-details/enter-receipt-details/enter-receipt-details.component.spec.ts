import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EnterReceiptDetailsComponent } from './enter-receipt-details.component';

describe('EnterReceiptDetailsComponent', () => {
  let component: EnterReceiptDetailsComponent;
  let fixture: ComponentFixture<EnterReceiptDetailsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EnterReceiptDetailsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EnterReceiptDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
