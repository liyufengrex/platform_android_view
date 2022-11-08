package com.rex.platform_android_view

import android.annotation.SuppressLint
import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.FrameLayout
import android.widget.TextView

/**
 *  android 渲染的自定义view 提供 flutter 使用
 */
class CustomView(context: Context, attrs: AttributeSet?) : FrameLayout(context, attrs) {

    private var textView: TextView? = null
    private var onKeyEventCallback: OnKeyEventCallback? = null

    init {
        val rootView = LayoutInflater.from(context).inflate(R.layout.layout_custom_view, this, true)
        initView(rootView)
    }

    private fun initView(rootView: View) {
        textView = rootView.findViewById(R.id.androidViewText)
        rootView.findViewById<Button>(R.id.androidViewButton).setOnClickListener {
            //模拟生成一个随机数传递到 flutter
            val randomNum = (0..10).random()
            onKeyEventCallback?.onKeyEventCallback(randomNum.toString())
        }
    }

    fun setOnKeyEventCallback(callback: OnKeyEventCallback?) {
        onKeyEventCallback = callback
    }

    @SuppressLint("SetTextI18n")
    fun getMessageFromFlutter(message: String) {
        textView?.text = "自来flutter的数据：$message"
    }

}

interface OnKeyEventCallback {
    fun onKeyEventCallback(message: String)
}