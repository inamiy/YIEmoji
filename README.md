YIEmoji 1.0.1
=============

NSString addition for iOS5+ Emoji.

Install via [CocoaPods](http://cocoapods.org/)
----------

```
pod 'YIEmoji'
```

To support iOS4, see tag `0.1` for more info.

Example
-------
```
NSString* text = @"😄😊😃☺1⃣test2⃣☀☔☁⛄";

NSLog(@"hasEmoji = %d",[text hasEmoji]); // YES
NSLog(@"trueLength = %d",[text emojiContainedTrueLength]); // 14
NSLog(@"emojiTrimmedString = %@",[text stringByTrimmingEmojis]); // test
```

TODO
----
- Add unit test
- Add OSX compatibility

Acknowledgement
---------------

- [punchdrunker/iOSEmoji](https://github.com/punchdrunker/iOSEmoji) (Japanese docs)

License
-------
`YIEmoji` is available under the [Beerware](http://en.wikipedia.org/wiki/Beerware) license.

If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.