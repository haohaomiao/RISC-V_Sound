import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';

// 定义全局变量存储文件路径
let textFileUri: string = '';
let audioFileUri: string = '';

// 创建文件选择器应用
@Entry
@Component
struct Index {
  @State message: string = 'RSICV-Sound';
  @State textFileMessage: string = 'Select a Text File';
  @State audioFileMessage: string = 'Select an Audio File';

  build() {
    Row() {
      Column() {
        // 显示主界面文字
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)

        // 文本文件选择按钮
        Button(this.textFileMessage).onClick(() => this.selectTextFile())

        // 音频文件选择按钮
        Button(this.audioFileMessage).onClick(() => this.selectAudioFile())
      }
      .width('100%')
    }
    .height('100%')
  }

  // 选择文本文件
  selectTextFile() {
    // 创建文档选择器选项
    const documentSelectOptions = new picker.DocumentSelectOptions();
    documentSelectOptions.maxSelectNumber = 1; // 选择一个文件
    documentSelectOptions.fileSuffixFilters = ['.txt']; // 只选择文本文件

    // 创建文档选择器实例
    const documentViewPicker = new picker.DocumentViewPicker();

    // 调用选择器
    documentViewPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
      textFileUri = documentSelectResult[0]; // 获取选择的文件URI
      console.info('Selected text file URI: ' + textFileUri);
      this.textFileMessage = `Selected: ${textFileUri}`; // 更新按钮文本显示选中的文件
    }).catch((err: BusinessError) => {
      console.error(`Error selecting text file: ${err.code}, ${err.message}`);
    });
  }

  // 选择音频文件
  selectAudioFile() {
    // 创建音频选择器选项
    const audioSelectOptions = new picker.AudioSelectOptions();

    // 创建音频选择器实例
    const audioViewPicker = new picker.AudioViewPicker();

    // 调用选择器
    audioViewPicker.select(audioSelectOptions).then((audioSelectResult: Array<string>) => {
      audioFileUri = audioSelectResult[0]; // 获取选择的音频URI
      console.info('Selected audio file URI: ' + audioFileUri);
      this.audioFileMessage = `Selected: ${audioFileUri}`; // 更新按钮文本显示选中的文件
    }).catch((err: BusinessError) => {
      console.error(`Error selecting audio file: ${err.code}, ${err.message}`);
    });
  }
}
