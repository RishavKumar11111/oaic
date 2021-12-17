import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { PreviewItemDetailsComponent } from './preview-item-details.component';

describe('PreviewItemDetailsComponent', () => {
  let component: PreviewItemDetailsComponent;
  let fixture: ComponentFixture<PreviewItemDetailsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PreviewItemDetailsComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PreviewItemDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
